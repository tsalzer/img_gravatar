Feature: eMail Encoding
  In order to display the correct Gravatar for a user
  The URL for the Gravatar image has to be derived from the email

  Scenario: Encode different "spellings" of the email
    When I encode the email "ihavean@email.com"
    Then I should get the email hash 3b3be63a4c2a439b013787725dfce802
    When I encode the email " ihavean@email.com"
    Then I should get the email hash 3b3be63a4c2a439b013787725dfce802
    When I encode the email "ihavean@email.com "
    Then I should get the email hash 3b3be63a4c2a439b013787725dfce802
    When I encode the email "IHaveAn@email.com"
    Then I should get the email hash 3b3be63a4c2a439b013787725dfce802
    When I encode the email "ihavean@EmaIl.CoM"
    Then I should get the email hash 3b3be63a4c2a439b013787725dfce802

  Scenario: Encode an email to a Gravatar Image URL
    Given email iHaveAn@email.com
    When I get the Gravatar URL for the user
    Then I should get a URI::HTTP object
    And I should get the URL http://www.gravatar.com/avatar/3b3be63a4c2a439b013787725dfce802

  Scenario: Encode an email to a Gravatar Image tag as a String
    Given email iHaveAn@email.com
    When I get the Gravatar image tag for the user
    Then I should get a String object

  Scenario: Check detection matcher for the detection scenarios
    Given the String "ThisStringDoesContainsAnEmail"
    Then I should not find "contain" in it
    And I should find "Contain" in it
    And I should find "contain" in any case in it

  Scenario: Email not detectable in the image tag
    Given user information Somebody <iHaveAn@email.com>
    When I get the Gravatar image tag for the user
    Then I should not find "iHaveAn" in it
    And I should not find "iHaveAn" in any case in it
    And I should not find "email" in it
    And I should not find "email" in any case in it

  Scenario: Name not detectable in the image tag
    Given user information Somebody <iHaveAn@email.com>
    When I get the Gravatar image tag for the user
    Then I should not find "Somebody" in it
    And I should not find "Somebody" in any case in it
