*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/custom_keywords.robot


*** Variables ***
${url}=     https://www.google.com/


*** Test Cases ***
Login To Cg SITE
    Login   http://192.168.0.10:8081/#login  administrator  admin

Open File Upload
    Open Doctype           File upload
    New Doc                File upload
    Select                 File upload    document_type       Settlement Advice
    Select Link            File upload    payer_type          AAROGYA INDIA HEALTH
    Save
    Sleep                  5s





