Release Notes
=============

1.1.0-rc.2
----------

Updated Pods:
UserRegistration 7.0.0

####Bug fixes:
PRI-185: Product Registration Application doesn't refresh with latest updates of janrain data



1.0.2-rc.3
----------

Updated Pods:
    UserRegistration 6.1.0-rc.2
    AppInfra 1.1.0
Merged Tagging banch to current release

1.0.1-rc.2
----------

Send email is true by default

####Bug fixes:
PRI-173: Serial number text filed doesn't come up when user try to enter the serial number or Hiding serial number text filed in semi-automatic product registration page(iPad:Landscape)
PRI-178: Localization update
PRI-168: No message displayed for user while looking summary data from PRX and Registering the Product
 

###Known issues:
Loclization not available for the below strings
    Continue in success screen
    Please select date in Register screen
    Ok for all PUIModleAlerts
    Missing CTN and Please enter CTN when user not provided CTN
    User not logged in


1.0.1-rc.6
----------

####Bug fixes:
Application is getting crash when entered serial number in semi-automatic page.
Date of Purchase miss matching between selected date and date of purchase displaying date.
User has to enter the serial number in semi-automatic product registration page , even serial number get from connected products.

1.0.1-rc.5
----------

PRI-171: As a user I shall be able to register single prdocut as per UI designed for semi automatic in potrait and landscape mode Both iPAd and iPhones

####Bug fixes:
PRI-165: Please enter date of purchase error message should be removed in semi automatic product registration page.
PRI-166: Application is get hanging when tap on "Register" button twice with out entered the CTN
PRI-167: Application is getting crash when tap on "please select the date" option in offline
PRI-170: User unable to register the product on iPhone 6 (device specific)
PRI-161: Loading icon spinning continuously when network speed is low

###Known issues:
ActivityIndicatior not according to the design.
In iPhone button are aligned with 100 pixel bottom gap to the content
Required fields are not hightlighting when error message displayed 

1.0.1-rc.4
----------

PRI-131: As a user I shall be able to register single product as per the UI defiened for semiautomatic registerscreen landscape

####Bug fixes:
PRI-164: While pulling the summary data from PRX, if the summary data is not present, the Date of purchase parameter is not displayed to user when date of purchase is equal to true

1.0.1-rc.3
----------

PRI-125: As a user I shall be able to register single Product as per UI designed for semi automatic in portrait mode

###Known issues:
Text font sizes are not according to the design
ActivityIndicatior not according to the design (because UserRegistaion is using old version of PhilipsUIKit) 

1.0.2
-----

####Bug fixes:

Fixed crash when serial number format is nil


1.0.1-rc.2
----------

####Bug fixes:

    Not caching, Products failed with Invalid date of purchase and required purchase date errors


1.0.1-rc.1
----------

####Bug fixes:

PRI-144: As a user i dont want to process inalid stored data like invalid CTN , invalid serial number
PRI-108: (On-Line)For invalid ctn and serial number also data storing in locally on the device, next time when user to try to register the product with valid data, invalid stored data confirmation pop-up is displayed for user always.
PRI-107: Error pop-up are displayed always with local stored invalids data, along with new product registered successful message for valid data


1.0.0
-----

Updated dependency libraries
    Registration 6.0.0
    PRXClient 1.0.0


1.0.0-rc.2 
----------

####Bug fixes:

PRI-122: Single product data getting registered multiple times with in user.


0.3.0-rc.2 
----------

PRI-103: Refresh user access token for token expiry error
PRI-104: Add configuration option in Demo app, So that user can change the test environment
PRI-66: Email configuration
PRI-110: Add Observers for User-registration and login

####Bug fixes:

PRI-89: two incorrect pop-up message is displayed for invalid serial number


0.3.0-rc.1 
----------

PRI-61: Register product regardless of internet connection
PRI-90: Getting list of Registered products and caching the data in mobile device
PRI-91: Structure the product information for PRX to store in JanRain Server

####Bug fixes:

Clicking on logout button in user registration screen not returning to initial screen.


###Known issues:

PRI-89: two incorrect pop-up message is displayed for invalid serial number
Refreshing AccessToken is not implemented Because server returning 500 error for some other reasons also.


0.2.0-rc.1 
----------

PRI-64: Only register one product instance

####Bug fixes:

PRI-81: Hint text is displayed as "Product name"
PRI-83: User is able to register the already registered product successfully
PRI-84: Incorrect purchase date is accepted by the app

###Known issues:

Refreshing AccessToken is not implemented Because server returning 500 error for some other reasons also.
Clicking on logout button in user registration screen not returning to initial screen.

0.0.3 
-------

PRI-60: Register product manually via sample application
PRI-80: User is not able to register the product successfully 

###Known issues:

Refreshing AccessToken is not implemented Because server returning 500 error for some other reasons also.
Clicking on logout button in user registration screen not returning to initial screen.