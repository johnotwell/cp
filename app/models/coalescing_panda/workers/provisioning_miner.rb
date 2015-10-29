require 'open-uri'
require 'open_uri_redirections'
require 'zip'

class CoalescingPanda::Workers::ProvisioningMiner
  attr_accessor :account, :user_ids, :course_ids, :section_ids, :enrollment_ids

  def initialize(account_id)
    @account = Account.find(account_id)
    @user_ids = [];
    @course_ids = [];
    @section_ids = [];
    @enrollment_ids = [];
  end

  def client
    Bearcat::Client.new(prefix: account.api_domain, token: account.api_token)
  end

  def perform
    Delayed::Worker.logger.debug "Downloading Provisioning Report"
    params = {
      'parameters[enrollments]' => true, 'parameters[users]' => true,
      'parameters[courses]' => true, 'parameters[sections]' => true,
      'parameters[xlist]' => true, 'parameters[include_deleted]' => true
    }
    url = download_report(:provisioning_csv, params)
    open(url, :allow_redirections => :safe) do |file|
      begin
        Delayed::Worker.logger.debug "Processing Provisioning Report"
        {users: User, courses: Course, sections: Section, enrollments: Enrollment, xlist: Section}.each do |k, v|
          process_zipped_csv_file(file, "#{k}.csv") do |row|
            begin
              id = v.create_from_csv(account, row)
              self.instance_variable_get("@#{v.to_s.downcase}_ids") << id if id.present?
            rescue => exception
              Delayed::Worker.logger.debug exception
            end
          end
        end
      ensure
        file.close unless file.nil?
      end
    end
  end

  def delete_records
    User.where.not(id: user_ids).destroy_all
    Course.where.not(id: course_ids).destroy_all
    Section.where.not(id: section_ids).destroy_all
    Enrollment.where.not(id: enrollment_ids).destroy_all
  end

  def process_zipped_csv_file(zip, file)
    Zip::InputStream.open(zip) do |io|
      while entry = io.get_next_entry
        if entry.name == file #io.read
          process_csv(io.read) { |row| yield(row) }
          break
        end
      end
    end
  end

  def process_csv(csv)
    csv_options = {:headers => true, :return_headers => false, :header_converters => :symbol}
    CSV.parse(csv, csv_options) { |row| yield(row) }
  end

  def download_report(report_name, report_params)
    report = client.start_report(account.canvas_account_id, report_name, report_params)
    report_id = report['id']
    loop do
      sleep 20
      report = client.report_status(account.canvas_account_id, report_name, report_id)
      break if report['status'] == 'complete' || report['status'] == 'error'
    end
    url = "#{account.api_domain}/files#{report['attachment']['url'].split('files').last}"
  end

end