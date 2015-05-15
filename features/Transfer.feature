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
	And I scroll the table all the way down	
	Then I select pay in method <payInMethod>
	And I scroll the table all the way up	
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
| source | target | payInMethod    | field1    | value1                      | field2   | value2         | field3                | value3        | field4  | value4   | field5 | value5     | field6 | value6  | field7  | value7 |
| EUR    | GBP    | UK Sort        | Sort      | 123456                      | Account  | 12345678       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | EUR    | -              | IBAN      | FR2830002004130000071693Z15 | BIC      | CRLYFRPP       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | USD    | -              | State     | NY                          | Address  | 1 Street       | Zip code              | 10001         | City    | New York | Routing| 121181976  | Account|012344321| -       | -      |
| GBP    | PLN    | -              | IBAN      | PL60102010260000042270201111| BIC      | ABNAPLPW       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | CHF    | -              | IBAN      | CH9300762011623852957       | BIC      | RBOSCHZXXXX    | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | NOK    | -              | IBAN      | NO9386011117947             | BIC      | DNBANOKK       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | SEK    | -              | IBAN      | SE3550000000054910000003    | BIC      | NDEASESS       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | DKK    | -              | IBAN      | DK1420000751141270          | BIC      | DABADKKK       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | AUD    | -              | BSB       | 033088                      | Account  | 123456         | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | HUF    | Hungarian local| Account   | 120000001200000012000000    | -        | -              | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | HUF    | IBAN           | IBAN      | HU42117730161111101800000000| BIC      | BUDAHUHB       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | GEL    | -              | IBAN      | GE29NB0000000101904917      | BIC      | BAGAGE22       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | HKD    | -              | Bank      | 003                         | Account  | 123456789      | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | INR    | -              | IFSC      | IDIB000A001                 | Account  | 12345          |>Business              |Private        | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | RON    | -              | IBAN      | RO49AAAA1B31007593840000    | BIC      | BUCUROBUXXX    | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | TRY    | -              | IBAN      | TR330006100519786457841326  | BIC      | TRHBTR2ATRY    | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | NZD    | -              | SWIFT     | ANZBNZ22102                 | Account  | 031587005000000| -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | SGD    | -              | Bank      | 7171                        | Branch   | 112            | Account               | 1234567       | -       | -        | -      | -          | -      | -       | -       | -      |
#| GBP    | ZAR    | -              | Bank      | 632005                      | Account  | 1234567        | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | CZK    | IBAN           | IBAN      | CZ8179400000001500007959    | BIC      | CEKOCZPP       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | CZK    | Czech          | prefix    | 200014                      | number   | 5399008012     | Code                  | 5400          | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | BGN    | -              | IBAN      | BG43STSA93000004746981      | BIC      | BNBGBGSD       | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | CAD    | -              |Institution| 001                         | Transit  | 25039-001      | Account               | 1234567       | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | MYR    | -              | SWIFT     | PHBMMYKL                    | Account  | 123456789012   | -                     | -             | -       | -        | -      | -          | -      | -       | -       | -      |
| GBP    | BRL    | -              |>Checking  | Checking                    | Account  | 12345678       | >Brb Banco De Brasilia| Banco Bradesco| Branch  | 001      | Tax    | 79443451115| phone  | 12345678|>Business|Private |
| GBP    | PHP    | -              | Address   | 1 Street                    | Post code| 10001          | City                  | Manilla       |>Ama Bank| Anz Bank | Account| 12345678901| phone  | 12345678| -       | -      |
| GBP    | NGN    | -              |>Access    | Access	                     | Account  | 0028669292     |  -                    | -             | -       | -        | -      | -          | -      |  -      | -       | -      |
| GBP    | PKR    | -              |>Al Baraka | Al Baraka	                 | Account  | 123456789      | >Business             | Private       | -       | -        | -      | -          | -      |  -      | -       | -      |
| GBP    | MAD    | -              |>Al Barid  | Al Barid	                 | Account  | 123456789012345678901234| >Business             | Private       | -       | -        | -      | -          | -      |  -      | -       | -      |