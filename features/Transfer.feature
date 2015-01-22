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
	Then I wait to see "Creating transfer"
	And I skip verification if needed
	And I wait to see "Contact customer support"
	
@new_transfer	
Scenario Outline: create new transfer
	Given I am logged in
	Then I touch "Send"
	Then I select source <source>
	And I select target <target>
	Then I touch "Send Money"
	And I wait to see "Select a recipient"
	Then I select pay in method <payInMethod>
	And I enter John Doe into form field Name
	And I enter john@doe.com into form field Email
	And I enter <value1> into form field <field1>
	And I enter <value2> into form field <field2>
	And I enter <value3> into form field <field3>
	And I enter <value4> into form field <field4>
	And I enter <value5> into form field <field5>
	And I enter <value6> into form field <field6>
	And I enter <value7> into form field <field7>
	Then I touch "Continue"
	And I wait to see "Confirm"
	Then I wait a bit
	Then I confirm the transfer
	And I skip verification if needed
	And I wait to see "Contact customer support"
	
Examples:
| source | target | payInMethod | field1 | value1                      | field2 | value2     | field3  | value3 | field4 | value4   | field5 | value5   | field6 | value6  | field7 | value7 |
| EUR    | GBP    | UK Sort        | Sort   | 123456                      | Account| 12345678   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | EUR    | -              | IBAN   | FR2830002004130000071693Z15 | BIC    | CRLYFRPP   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
#| GBP    | USD    | -              | State  | CA                          | Address| 1 Street   | Zip code| 50001  | City   | New York | Routing| 121181976| Account|012344321| -      | -      |
| GBP    | PLN    | -              | IBAN   | PL60102010260000042270201111| BIC    | ABNAPLPW   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | CHF    | -              | IBAN   | CH9300762011623852957       | BIC    | RBOSCHZXXXX| -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | NOK    | -              | IBAN   | NO9386011117947             | BIC    | DNBANOKK   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | SEK    | -              | IBAN   | SE3550000000054910000003    | BIC    | NBBKSESS   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | DKK    | -              | IBAN   | DK1420000751141270          | BIC    | DABADKKK   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | AUD    | -              | BSB    | 033088                      | Account| 123456     | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
| GBP    | HUF    | Hungarian local| Account| 120000001200000012000000    | -      | -          | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |
#| GBP    | HUF    | IBAN           | IBAN   | HU42117730161111101800000000| BIC    | BUDAHUHB   | -       | -      | -      | -        | -      | -        | -      | -       | -      | -      |

