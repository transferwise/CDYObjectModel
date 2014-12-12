Feature: Transfer
	As a customer
	I want to be able to enter transaction details
	So I can make international money transfers

Scenario: EUR -> GBP
	Given I am logged in
	Then I touch "Send"
	Then I select source EUR
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
	And I wait to see "Bank transfer"
	
Scenario: GBP -> PLN
	Given I am logged in
	Then I touch "Send"
	Then I select source GBP
	And I select target PLN
	Then I touch "Send Money"
	Then I wait a bit
	And I wait to see "Select a recipient"
	And I enter John Doe into form field Name
	And I enter john@doe.com into form field Email
	And I enter PL60102010260000042270201111 into form field IBAN
	And I enter ABNAPLPW into form field BIC
	Then I touch "Continue"
	And I wait to see "Confirm"
	Then I wait a bit
	Then I touch "Confirm"
	And I wait to see "Bank transfer"