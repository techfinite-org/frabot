*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/custom_keywords.robot


*** Variables ***
${url}=     https://www.google.com/



*** Test Cases ***
Open and Close Browser
    Open Browser    ${url}    chrome
    Sleep           5s
    Close Browse




