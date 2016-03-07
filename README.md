Coalescing Panda
=

Coalescing Panda is a rails engine that provides OAuth2 authentication, and simplifies LTI tools for Canvas.



Configuration
-
---

Add the following line to routes.rb file. passing in the title to lti_options.

    mount CoalescingPanda::Engine, at: "/lti"

in your routes file below where you mounted your engine use the following to specify custom navigation:

    lti_nav course: 'controller#action', lti_options:{enabled: true, text: 'course link title', visibility: 'admins'}


    lti_nav account: 'controller#action', lti_options:{enabled: true, text: 'admin link title'}

    lti_nav :navigation_type: 'controller#action', lti_options:{'hash of options to use for the navigation'}

The paths for each of the navigation items will be the lti_mount path followed by the navigation symbol you provide, i.e. "lti_nav :account" will be defined as lti_mount_path/account


The tool will generate XML that can be used to configure the tool in Canvas. The url for the config will be the lti_mount path followed by config. i.e:

    /lti/config

An initializer will also need to be created to populate the options for lti tool and lti navigation. This can be done by creating an initializer
in the intializers folder in your rails project, and includeing the following:

    CoalescingPanda.lti_options= {title:'LTI Tool Title'}
    CoalescingPanda.lti_environments = { domain: 'https://production-instance-of-tool.com', test_domain: 'https://test-instance-of-tool.com' }
    CoalescingPanda.stage_navigation(:course, {enabled: true, text: 'course link title', visibility: 'admins'})
    CoalescingPanda.stage_navigation(:admin, {enabled: true, text: 'admin link title', visibility: 'admins'})

### DB Setup

populate the "CoalescingPanda::LtiAccount" model for each oauth key/secret pair you are using. Optionally if you want to use Oauth2 you can fill those values as well

###LTI Authentication
Oauth singatures can be validated by using lti_authorize as a before filter

    before_action :lti_authorize!, only: [:course]

or to include role checking

    before_action(:only => [:course]) { |c| c.lti_authorize!(:admin, :teacher) }

###OAuth2
To use OAuth2 create a before filter in your controller with :canvas_oath2 as the method, i.e:

    before_action :canvas_oauth2, :only => [:course]


####Enviroment Variables
The following environment variable can be set to use http instead of https

    OAUTH_PROTOCOL=http


#### SAFARI SESSION FIX
When redirecting from the lti landing controller to the new application, the session will be lost if the new application is opened in an iFrame. In order to work around this problem, do the following:

1) before you redirect add
    token = CoalescingPanda::Session.create_from_session(session)
    redirect_to conferences_path(restore_session_token: token)
2) then in the applications application_controller.rb, add the following code snippet

    before_filter :restore_session

    def restore_session
      CoalescingPanda::Session.restore_from_token(params[:restore_session_token], session) if params[:restore_session_token].present?
    end

### Coalescing Panda Models
Coalescing panda now creates the canvas model structure for you. But to eliminate the need to write CoalescingPanda::Course instead of Course, all you have to do is run a rake task.

rake coalescing_panda:create_models

This will create a model Course that inherits from CoalescingPanda:Course and maintains all of the associations.
Therefore you will still be able to write your model methods inside course.rb.

### CoalescingPanda::Workers::CourseMiner
Coalescing Panda now comes with a reusable data miner. What this worker does is makes api calls in the background with delayed jobs to populate all of the records for your given course. To start the worker run the following

worker = CoalescingPanda::Workers::CourseMiner.new(Course.first, [:sections, :users, :enrollments, :assignments, :submissions])
session[:canvas_batch_id] = worker.batch.id
worker.start

This will create the worker, add it to the session to track it's progress, and start it.

### Canvas Batches
If you would like the progress bar for a canvas batch such as the course miner to show, include the following snippet into your template.

<%= render "coalescing_panda/canvas_batches/canvas_batch_flash" %>

Add the following to your application.js

    //= require coalescing_panda/canvas_batch

Add the following to your application.css.scss

    @import 'coalescing_panda/progress';

This partial requires a method called current_batch. You can add this by adding the following line to your application controller:

    helper CoalescingPanda::Engine.helpers

To enable progress bar and batch success / failure callbacks:

  the session[:canvas_batch_id] session variable must be set before the server returns your template.
  then you would do something like this to get the progress and callbacks to work (Callbacks are optional)
  new window.CoalescingPanda.CanvasBatchProgress(successCallback, errorCallback) if $('#batch-progress').length > 0

If you would like to customize the flash messages simply pass a javascript object as the third param
    new window.CoalescingPanda.CanvasBatchProgress(successCallback, errorCallback, {queued: "example queued message", completed: "example completed message", started: "example started message", error: "example error message"})

To Enable settings an interval for how often canvas batches should autoload set the following to an integer in minutes
    account.settings[:canvas_download_interval] = 15 # 15 Minutes
