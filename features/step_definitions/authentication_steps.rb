Given /^I log in with Google$/ do
	touch("view marked:'Google'")
	#wait for page to load
	macro 'I wait a bit'
	macro 'I wait a bit'
	if (!element_exists("webView css:'button[id=\"submit_approve_access\"]'"))
		#no valid authentication token
		macro 'I wait for web view field Email to appear'
		macro 'I enter tw.calabash@gmail.com into web view field Email'
		macro 'I enter va1uutaPost into web view field Passwd'
		macro 'I touch web view field signIn'
	end
	macro 'I wait for web view button with id submit_approve_access to appear'
	macro 'I wait a bit'
	macro 'I wait a bit'
	macro 'I touch web view button with id submit_approve_access'
	macro 'I wait a bit'
	macro 'I wait to see "Logging in..."'
	macro 'I wait until I don\'t see "Logging in..."'
	macro 'I wait a bit'
	closePaymentScreen()
end

Given /^I log in with Yahoo$/ do
	touch("view marked:'Yahoo'")
	#wit for page to load
	macro 'I wait a bit'
	macro 'I wait a bit'
	macro 'I wait a bit'
	macro 'I wait a bit'
	if (element_exists("webView css:'button[id=\"login-signin\"]'"))
		macro 'I wait for web view field username to appear'
		macro 'I enter tw.calabash@yahoo.com into web view field username'
		macro 'I enter va1uutaPost into web view field passwd'
		macro 'I touch web view button with id login-signin'
	end
	wait_for_elements_do_not_exist(["webView"], :timeout => 5)
	macro 'I wait a bit'
	closePaymentScreen()
end