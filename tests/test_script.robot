*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/custom_keywords.robot
Library     ../libraries/custom_keywords.py


*** Variables ***
${url}=     https://www.google.com/



*** Test Cases ***
Open and Close Browser
    Open Browser    ${url}
    Sleep           5s
    Close Browse





