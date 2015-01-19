Feature: Tests if the cron jobs are performed correctly
  Scenario: when the time is right the cron has to send unread messages to all users with notification flag
    Given There are 2 users with notification flags
    When They both send to each other messages
    And Notification about unread notifications is sent
    Then Then unread_emails has to be sent
