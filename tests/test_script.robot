*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/custom_keywords.robot


*** Variables ***
${url}=     https://www.google.com/



*** Test Cases ***
Open and Close Browser
    Login            http://192.168.0.10:8081/#login    administrator     admin
    Open Doctype     SA Downloader Run Log
    New Doc          SA Downloader Run Log

#    Fill             Select           document_type      Settlement Advice
#    Fill             Link             payer_type         AAROGYA INDIA HEALTH
#    Sleep            5s
#    Fill             Select           document_type      Write Off
#    Fill             Date             wo_date            17-05-2025
#    Save Doc
    Sleep            5s
    Is Saved         5s        
    Is Saved         2s               0





