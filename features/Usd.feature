#  CALABASH AUTOMATED UI TESTING iOS


#####################################
# Execute in simulator:
#
# reset simulator prior to running
#
# > cucumber
#
#####################################
# Execute on device: 
#
# Build and install for profiling. Close instruments.
#
# > BUNDLE_ID=com.transferwise.dev.Transferwise-cal DEVICE_TARGET=<Device UDID> DEVICE_ENDPOINT=http://<device ip on local wifi>:37265 cucumber
#
#####################################


Feature: Authentication
	As a customer
	I want to be able to transfer money from USD
	I want to be able to do this with ACH
	
Scenario: Create from USD transfer and pay with ACH
	Given I am logged in as an american
	Then I touch "Send"
	Then I select source USD
	And I select target GBP
	Then I touch "Send Money"
	And I wait to see "Select a recipient"
	Then I touch "UK Sort"
	Then I grant access to Address Book in form field Name
	And I enter John Doe into form field Name
	And I enter john@doe.com into form field Email
	And I enter Somewhere 42 into form field Address
	And I enter SW1 112 into form field Post
	And I enter London into form field City
	And I enter 123456 into form field Sort
	And I enter 12345678 into form field Account
	Then I touch "Continue"
	And I wait to see "Confirm"
	Then I wait a bit
	Then I touch "Confirm"
	Then I wait to see "Creating transfer"
	And I skip verification if needed
	And I wait to see "Bank debit (ACH)"
	Then I touch the "Bank debit (ACH)" button
	And I wait to see "Pay by direct debit"
	Then I enter 999999989 into form field routing
	And I enter 5035623253 into form field account
	Then I press the "Connect to my account" button
	And I wait to see "Confirm your payment"
	Then I enter tr@nswise.bank1 into form field Username
	And I enter bank1 into form field Password
	And I touch the "Pay $1 000.00 with DagBank" button
	Then I wait a bit
	And I wait to see "AchWaitingView"
	Then I wait a long time until I don't see "AchWaitingView"
	Then I wait to see "OK"
	And I touch "OK"
	Then I wait to see "Got it!"
	And I touch "Got it!"
	Then I wait to see "Transfers list"