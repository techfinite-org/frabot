*** Settings ***
Library           SeleniumLibrary
Library           String
Library           ../libraries/custom_keywords.py
Variables         ../libraries/variables.py


*** Keywords ***

Login
    [Arguments]    ${url}    ${username}    ${password}   ${browser}=chrome
    Open Browser                     ${url}               ${browser}
    Maximize Browser Window
    Input Text                       id=login_email       ${username}
    Input Text                       id=login_password    ${password}
    Click Element                    css=.btn-login
    Wait Until Element Is Visible    id=navbar-search    ${config}[max_wait_time]


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
    ${doctype_list}=    Catenate     SEPARATOR=${SPACE}         ${doctype}                List
    Wait Until Element Is Visible    id=navbar-search           ${config}[max_wait_time]
    Click Element                    id=navbar-search
    Input Text                       id=navbar-search           ${doctype_list}
    Press Keys                       id=navbar-search           RETURN
    Wait Until Keyword Succeeds      ${config}[max_wait_time]   1s                        Check URL   ${doctype}


New Doc
    [Arguments]    ${doctype}
    ${result}=     Run Keyword And Return Status    Check URL    ${Doctype}
    IF    not ${result}
        Open Doctype    ${doctype}
    END
    ${label}=                        Catenate   SEPARATOR=${SPACE}   Add  ${doctype}
    Wait Until Element Is Visible    xpath=//button[contains(., "${label}")]    ${config}[max_wait_time]
    Click Element                    xpath=//button[contains(., "${label}")]


Select
     [Arguments]    ${doctype}     ${field_name}    ${value}
     Wait Until Element Is Visible       xpath=//select[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]    ${config}[max_wait_time]
     Select From List By Value           xpath=//select[@data-fieldname="${field_name}" and @data-doctype="${doctype}"]    ${value}

Select Link
    [Arguments]    ${doctype}     ${field_name}    ${value}
    Wait Until Element Is Visible       xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     ${config}[max_wait_time]
    Input Text                          xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     ${value}
    Sleep                               2s
    Press Keys                          xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     RETURN

Data
     [Arguments]    ${doctype}     ${field_name}    ${value}
     Wait Until Element Is Visible       xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]    ${config}[max_wait_time]
     Input Text                          xpath=//input[@data-fieldname="${field_name}" and @data-doctype="${doctype}"]    ${value}


Click Button
    [Arguments]     ${field_name}
    ${doctype}=     Get Current Doctype Name
    Wait Until Element Is Visible       xpath=//button[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]     ${config}[max_wait_time]
    Click Element                       xpath=//button[@data-fieldname="${field_name}" and @data-doctype="${Doctype}"]


Attach
    [Arguments]   ${field_name}    ${value}
    ${doctype}=                         Get Current Doctype Name
    Click Button                        ${field_name}
    Wait Until Page Contains Element    xpath=//input[@type='file']                                                ${config}[max_wait_time]
    Execute Javascript                  document.querySelector("input[type='file']").classList.remove("hidden")
    Wait Until Element Is Visible       xpath=//input[@type='file']                                                ${config}[max_wait_time]
    Choose File                         xpath=//input[@type='file']                                                ${value}
    Wait Until Element Is Visible       xpath=//button[@class='btn btn-primary btn-sm btn-modal-primary']          ${config}[max_wait_time]
    Click Element                       xpath=//button[@class='btn btn-primary btn-sm btn-modal-primary']

Save Doc
    Wait Until Element Is Visible       xpath=//button[@data-label='Save']      ${config}[max_wait_time]
    Click Element                       xpath=//button[@data-label='Save']

Select All
    Wait Until Element is Visible       xpath=//input[@type="checkbox" and @title="Select All"]     ${config}[max_wait_time]
    Select Checkbox                     xpath=//input[@type="checkbox" and @title="Select All"]

Date
    [Arguments]    ${doctype}    ${field_name}    ${value}
    ${xpath}=    Set Variable    //input[@data-fieldname="${field_name}" and @data-doctype="${doctype}"]
    Wait Until Element Is Visible    ${xpath}    10s
    Click Element    ${xpath}
    Sleep    0.5s
    Press Keys    ${xpath}    ${value}
    Press Keys    ${xpath}     ESCAPE

Get Current Doctype Name
    ${doctype}=    Execute Javascript    return cur_frm.doctype;
    RETURN         ${doctype}

Get Field Type
    [Arguments]    ${fieldname}
    ${js}=    Catenate    SEPARATOR=\n
    ...    var fieldname = '${fieldname}';
    ...    var field = cur_frm.meta.fields.find(f => f.fieldname === fieldname);
    ...    if(field) {
    ...        return field.fieldtype;
    ...    } else {
    ...        throw(`Field '${fieldname}' not found`);
    ...    }
    ${fieldtype}=    Execute Javascript    ${js}
    RETURN    ${fieldtype}

Fill
    [Arguments]     ${field_name}     ${value}
    ${field_type}=         Get Field Type          ${field_name}
    ${normalized_type}=    Convert To Lowercase    ${field_type}    
    ${keyword_map}=        Create Dictionary
    ...    select=Select
    ...    link=Select Link
    ...    date=Date
    ...    data=Data
    ${doctype}=  Get Current Doctype Name
    ${has_key}=  Run Keyword And Return Status    Dictionary Should Contain Key    ${keyword_map}    ${normalized_type}
    Run Keyword If    ${has_key} != None
    ...    Run Keyword     ${keyword_map['${normalized_type}']}    ${doctype}    ${field_name}    ${value}
    ...    ELSE
    ...    Fail    Unsupported field type: ${field_type}

Get Doc Name
    ${doc_name}=    Execute Javascript    return cur_frm.doc.name;
    RETURN          ${doc_name}
    
Check Doc Is Saved
    ${is_dirty}=    Execute Javascript    return cur_frm.is_dirty();
    Run Keyword If    '${is_dirty}' == 'True'
    ...                Fail     Document Not Saved
    Run Keyword If    '${is_dirty}' == 'False'
    ...                Return From Keyword    True
    
Is Saved
    [Arguments]    ${wait_time}=${config}[max_wait_time]    ${raise_error}=1
    ${doctype}=    Get Current Doctype Name

    ${status}    ${value}=    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    ${wait_time}    1s    Check Doc Is Saved

    Run Keyword If    '${status}' == 'FAIL' and ${raise_error} == 1
    ...    Fail    Document "${doctype}" is not saved within ${wait_time}

    Run Keyword If    '${status}' == 'FAIL' and ${raise_error} == 0
    ...    Return From Keyword    False

    Return From Keyword    True
    
Get Field Value
    [Arguments]    ${field_name}
    ${value}=    Execute Javascript    return cur_frm.doc.${field_name};
    RETURN    ${value}
    
    




    

    








