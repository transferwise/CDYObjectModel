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


Feature: Recipients
	As a customer
	I want to add recipient
	And send money to existing recipients
	
Scenario: Add new Recipient
	Given I am logged in
	Then I touch "Recipients"
	And I wait to see "AddButton"
	Then I touch the "AddButton" button
	And I wait to see "Add recipient"
	And I grant access to Address Book in form field "Recipient's Name"
	Then I enter Somebody Somewhere into form field Recipient's Name
	And I enter somebody@somewhere.ff into form field Recipient's Email (Optional)
	And I enter EE252200001107666896 into form field IBAN
	And I enter HABAEE2X into form field Banck code (BIC/SWIFT)
	Then I touch the "Add" button
	Then I wait to see "Validating..."
	Then I wait until I don't see "Validating..."
	Then I wait until I see "Recipients"
	