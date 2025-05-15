*** Settings ***
Library    SeleniumLibrary
Library    String
Library    ../libraries/keyword_utilities.py


*** Keywords ***

Login
    [Arguments]    ${url}    ${username}    ${password}   ${browser}=chrome
    Open Browser                     ${url}               ${browser}
    Maximize Browser Window
    Input Text                       id=login_email       ${username}
    Input Text                       id=login_password    ${password}
    Click Element                    css=.btn-login
    Wait Until Element Is Visible    id=navbar-search     30s


Go To URL
    [Arguments]    ${Doctype}=None    ${navigate_url}=None
    Run Keyword If    '${navigate_url}' != 'None'    Go To    ${navigate_url}
    ...                ELSE IF    '${Doctype}' != 'None'
    ...                ${url}=    Get Location
    ...                ${navigate_url}=    Get Doctype Url    ${url}    ${Doctype}
    ...                Go To    ${navigate_url}


Check URL
    [Arguments]    ${Doctype}
    ${current_url}=        Get Location
    ${expected_part}=      Get Doctype Url   ${current_url}      ${Doctype}
    Should Contain         ${current_url}    ${expected_part}    URL does not contain expected path


Open Doctype
    [Arguments]    ${doctype}
    ${doctype_list}=    Catenate     SEPARATOR=${SPACE}   ${doctype}       List
    Wait Until Element Is Visible    id=navbar-search     timeout=30s
    Click Element                    id=navbar-search
    Input Text                       id=navbar-search     ${doctype_list}
    Press Keys                       id=navbar-search     RETURN
    Wait Until Keyword Succeeds      30s                  1s               Check URL    ${doctype}


New Doc
    [Arguments]    ${doctype}
    ${result}=     Run Keyword And Return Status    Check URL    ${Doctype}
    IF    not ${result}
        Open Doctype    ${doctype}
    END
    ${label}=                        Catenate   SEPARATOR=${SPACE}   Add  ${doctype}
    Wait Until Element Is Visible    xpath=//button[contains(., "${label}")]    30s
    Click Element                    xpath=//button[contains(., "${label}")]


Select
     [Arguments]    ${doctype}     ${field_name}    ${value}
     Wait Until Element Is Visible       xpath=//select[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]    30s
     Select From List By Value           xpath=//select[@data-fieldname="${field_name}" and @data-doctype="${doctype}"]    ${value}

Select Link
    [Arguments]    ${doctype}     ${field_name}    ${value}
    Wait Until Element Is Visible       xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     30s
    Input Text                          xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     ${value}
    Sleep                               2s
    Press Keys                          xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     RETURN



Click Button
    [Arguments]    ${doctype}     ${field_name}
    Wait Until Element Is Visible       xpath=//button[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     30s
    Click Element                       xpath=//button[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]

Attach
    [Arguments]    ${doctype}     ${field_name}  ${value}
    Click Button                        ${doctype}                                                                          ${field_name}
    Wait Until Element Is Visible       xpath=//input[@type='file']                                                         10s
    Execute Javascript                  document.querySelector("input[type='file']").classList.remove("hidden")
    Wait Until Element Is Visible       xpath=//input[@type='file']                                                         10s
    Choose File                         xpath=//input[@type='file']                                                         ${value}
    Sleep                               2s
    Wait Until Element Is Visible       xpath=//button[@class='btn btn-primary btn-sm btn-modal-primary']                   10s
    Click Element                       xpath=//button[@class='btn btn-primary btn-sm btn-modal-primary']
