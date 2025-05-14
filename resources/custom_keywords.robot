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
    [Arguments]    ${Doctype}
    ${doctype_list}=    Catenate     SEPARATOR=${SPACE}   ${Doctype}       List
    Wait Until Element Is Visible    id=navbar-search     timeout=30s
    Click Element                    id=navbar-search
    Input Text                       id=navbar-search     ${doctype_list}
    Press Keys                       id=navbar-search     RETURN
    Wait Until Keyword Succeeds      30s                  1s               Check URL    ${Doctype}


New Doc
    [Arguments]    ${Doctype}
    ${result}=     Run Keyword And Return Status    Check URL    ${Doctype}
    IF    not ${result}
        Open Doctype    ${Doctype}
    END
    ${label}=                        Catenate   SEPARATOR=${SPACE}   Add  ${Doctype}
    Wait Until Element Is Visible    xpath=//button[contains(., "${label}")]    30s
    Click Element                    xpath=//button[contains(., "${label}")]



SELECT
    [Arguments]    ${field_name}    ${value}
    Sleep       5s
    Wait Until Element Is Visible       xpath=//select[@class="input-with-feedback form-control ellipsis bold"]    5








