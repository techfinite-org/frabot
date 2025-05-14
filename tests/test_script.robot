*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}=     https://www.google.com/

*** Test Cases ***
Open and Close Browser
    Open Browser    ${url}    chrome
    Sleep           10s
    Close Browser


