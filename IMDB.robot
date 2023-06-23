*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${movie_name}     The Shawshank Redemption
${first_element_in_List}    ${EMPTY}

*** Test Cases ***
scenario_1
    [Setup]    Open Browser    https://www.imdb.com    Chrome
    Input text    id=suggestion-search    ${movie_name}
    Sleep    3
    Click Button    id=suggestion-search-button
    Sleep    3
    ${first_film}    Get WebElement    class=ipc-metadata-list-summary-item__t
    ${title}    Get Text    ${first_film}
    Should Be Equal As Strings    ${title}    ${movie_name}
    ${titles}    Get WebElements    class=ipc-metadata-list-summary-item__t
    FOR    ${title}    IN    @{titles}
        ${name}    Get Text    ${title}
        Should Contain    ${name}    ${movie_name}    ignore_case=True
    END
    [Teardown]    Close Browser

scenario_2
    [Setup]    Open Browser    https://www.imdb.com    Chrome
    Click Element    id=iconContext-menu
    sleep    3
    Click Element    xpath://a[@class='ipc-list__item nav-link sc-cwSeag jkuMrq ipc-list__item--indent-one' and @href='/chart/top/?ref_=nv_mv_250']
    Page Should Contain Element    xpath://span[@class='ipc-list-item__text' and contains(text(), 'Top 250 Movies')]
    sleep    5
    ${first_element_in_List}    Get Text    xpath=//td[@class='titleColumn']/a
    Should Be Equal    ${first_element_in_List}    The Shawshank Redemption
    [Teardown]    Close Browser

scenario_3
    [Setup]    Open Browser    https://www.imdb.com    Chrome
    Wait Until Page Contains Element    css=div.sc-hHTYSt.bSEIOj
    Maximize Browser Window
    Wait Until Page Contains Element    xpath://label[@for="navbar-search-category-select"]
    Click Element    xpath://label[@for="navbar-search-category-select"]
    sleep    3
    Click Element    xpath://a[contains(@href, "search/?ref_=nv_sr_menu_adv")]
    Wait Until Page Contains Element    //*[@id="header"]
    Click Element    xpath=//a[@href='/search/title']
    Wait Until Page Contains Element    //*[@id="header"]/h1
    Select Checkbox    id=title_type-1
    sleep    3
    Select Checkbox    id=genres-1
    sleep    3
    Input text    name=release_date-min    2010
    Input text    name=release_date-max    2020
    sleep    3
    Click Button    css=button.primary
    sleep    3
    Click Link    User Rating
    sleep    3
    @{release_year_elements}=    Get Webelements    xpath://span[@class="lister-item-year text-muted unbold"]
    @{user_rating_elements}=    Get Webelements    xpath://div[@class="ratings-imdb-rating strong"]/strong
    @{release_years}=    Create List
    @{user_ratings}=    Create List
    @{int_release_years}=    Create List
    FOR    ${element}    IN    @{release_year_elements}
        ${text}=    Get Text    ${element}
        ${year}=    Evaluate    ${text.strip("()I ")}
        Append To List    ${release_years}    ${year}
    END
    FOR    ${element}    IN    @{user_rating_elements}
        ${text}=    Get Text    ${element}
        Append To List    ${user_ratings}    ${text}
    END
    ${release_years_in_range}=    Evaluate    all(2010 <= year <= 2020 for year in ${release_years})
    ${sorted_user_ratings}=    Evaluate    sorted(${user_ratings}, reverse=True)
    ${ratings_sorted}=    Evaluate    ${user_ratings} == ${sorted_user_ratings}
    ${Generes}    Get WebElements    Class=genre
    FOR    ${element}    IN    @{Generes}
        ${genre}    Get Text    ${element}
        Should Contain    ${genre}    Action
    END
    [Teardown]    Close Browser
