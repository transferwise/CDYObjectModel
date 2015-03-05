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


Feature: Transfer
	As a customer
	I want to be able to log in using different login methods
	So I can make international money transfers and be secure!
	
Scenario: Google
	Given I am past the Welcome Screen
	Then I touch the "Log in" button
	And I wait a bit
	Then I log in with Google
	Then I wait to see "Transfers list"
	And I log out

Scenario: TransferWise
	Given I am past the Welcome Screen
	Then I touch the "Log in" button
	Then I wait a bit
	And I enter juhan@transferwise.com into form field Your email
	And I enter q1w2e3r4 into form field Password
	Then I touch the "Log in" button
	Then I wait to see "Logging in..."
	Then I wait until I don't see "Logging in..."
	Then I wait to see "Transfers list"
	And I log out