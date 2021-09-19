*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library           RPA.Browser.Selenium
Library           RPA.HTTP
Library           RPA.Tables

*** Keywords ***
Open the robot order website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order

*** Keywords ***
Download the order file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

*** Keywords ***
Get orders
    ${ordersFromCsv}=    Read table from CSV    orders.csv    header=True
    [Return]    ${ordersFromCsv}

*** Keywords ***
Close the annoying modal
    Click Button When Visible    class:btn-dark

*** Keywords ***
Fill the form
    [Arguments]    ${row}
    Select From List By Value    head    ${row}[Head]
    Select Radio Button    body    ${row}[Body]
    Input Text    xpath://input[@type='number']    ${row}[Legs]
    Input Text    address    ${row}[Address]

*** Keywords ***
Preview the robot
    Click Button When Visible    id:preview

*** Keywords ***
Submit the order
    Click Button When Visible    id:order
    Wait Until Page Contains Element    id:receipt




*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    Download the order file
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}    
        Preview the robot
        Submit the order
    #    ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
    #    ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
    #    Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
    #    Go to order another robot
    END
    # Create a ZIP file of the receipts
