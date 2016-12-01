Feature: Scenario Outline


  Scenario: Add tag to scenario outline
    Given a file named "outline.feature" with:
    """
      Feature: Outline Sample

        @foo
        Scenario Outline: Test state
          Given <state> without a table
          Given <other_state> without a table

          Examples: Rainbow colours
            | state   | other_state |
            | missing | passing     |
            | passing | passing     |
            | failing | passing     |

    """
    When I run cuketagger with "add:fails add:bar outline.feature:4"
    Then I should see:
    """
      Feature: Outline Sample

        @foo @fails @bar
        Scenario Outline: Test state
          Given <state> without a table
          Given <other_state> without a table

          Examples: Rainbow colours
            | state   | other_state |
            | missing | passing     |
            | passing | passing     |
            | failing | passing     |

    """
