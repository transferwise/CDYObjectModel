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
	And I grant access to Address Book in form field Name
	Then I enter Somebody Somewhere into form field Name
	And I enter somebody@somewhere.ff into form field Email
	And I enter EE252200001107666896 into form field IBAN
	And I enter HABAEE2X into form field Bank code (BIC/SWIFT)
	Then I touch the "Add" button
	Then I wait to see "Validating..."
	Then I wait until I don't see "Validating..."
	Then I wait to see "Recipients"
	And I see row with label "Somebody Somewhere"	
	
Scenario: Make tranfser to existing Recipient
	Given I am logged in
	Then I touch "Recipients"
	And I wait to see "Somebody Somewhere"
	Then I touch "Somebody Somewhere"
	And I wait to see "Send money"
	Then I touch the "Send money" button
	And I wait to see "CloseButton"
	Then I wait a bit
	Then I wait a bit
	Then I touch the "Send Money" button
	And I wait to see "Confirm"
	Then I wait a bit
	Then I confirm the transfer
	And I skip verification if needed
	And I wait to see "Contact customer support"
	
Scenario: Delete existing Recipient
	Given I am logged in
	Then I touch "Recipients"
	And I wait to see "Somebody Somewhere"
	Then I touch "Somebody Somewhere"
	And I wait to see "DeleteRecipient"
	Then I touch "DeleteRecipient"
	And I wait a bit
	Then I touch "Delete"
	Then I wait to see "Deleting..."
	Then I wait until I don't see "Deleting..."
	And I wait to see "Recipients"