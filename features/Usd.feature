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
	
Scenario: Create from USD transfe and pay with ACH
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
	And I enter 123456 into form field Sort
	And I enter 12345678 into form field Account
	Then I touch "Continue"
	And I wait to see "Confirm"
	Then I wait a bit
	Then I touch "Confirm"
	Then I wait to see "Creating transfer"
	And I skip verification if needed
	And I wait to see "Contact customer support"