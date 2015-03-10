Feature: Delete profile

Scenario: Delete existing Recipient
	Given I am logged in
	Then I touch "Recipients"
	And I wait to see "Somebody Somewhere"
	Then I swipe left on a row with label "Somebody Somewhere"
	And I wait to see "Delete"
	Then I touch "Delete"
	Then I wait for an alert and agree with button "Delete"
	Then I wait to see "Deleting..."
	Then I wait until I don't see "Deleting..."
	And I see "Recipients"