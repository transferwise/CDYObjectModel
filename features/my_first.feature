Feature: Transfer
	As a customer
	I want to be able to enter transaction details
	So I can make international money transfers

Scenario: EUR -> GBP
	Given I am logged in
	Then I touch "Send"
	Then I select source EUR
	Then I select target GBP	

