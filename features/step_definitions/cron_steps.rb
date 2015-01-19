  include ApplicationHelper
  include ScheduledMailer
  include EmailSpec::Helpers
  include EmailSpec::Matchers



Given(/^There are (\d+) users with notification flags$/) do |arg1|
      num=arg1.to_i
      FactoryGirl.create_list(:user,num,:newsletters=>true)
      User.where(:newsletters=>true).count.should ==num
end

When(/^They both send to each other messages$/) do
  @user1=User.first
  @user2=User.last
  # send instant message to each other
  @user1.send_message(@user2, 'hello '+@user2.first_name, 'no-subject')
  @user2.send_message(@user1, 'hello '+@user1.first_name, 'no-subject')
  count_unread_messages(@user1).should==1 && count_unread_messages(@user2).should==1
end

When(/^Notification about unread notifications is sent$/) do
  # this sends emails to those 2 users
  scheduled_unread_messages_email
end

Then(/^Then unread_emails has to be sent$/) do
  mailbox_for(User.last.email).size.should == parse_email_count(1)
  # include ActionController::UrlWriter - old rails
  #unread_emails_for(User.last.email).size.should == parse_email_count(1)

end
