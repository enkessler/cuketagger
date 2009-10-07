Feature: CukeTagger
  In order to quickly add or remove tags
  As a Cucumber user
  I want to use cuketagger

  Background:
    Given a file named "sample.feature" with:
      """
      # Feature comment
      @one
      Feature: Sample

        @two @three
        Scenario: Missing
          Given missing

        # Scenario comment
        @three
        Scenario: Passing
          Given passing
            | a | b |
            | c | d |

      """


  Scenario: Remove tags from specific scenario
    When I run cuketagger with "remove:two remove:three sample.feature:6"
    Then I should see:
      """
      # Feature comment
      @one
      Feature: Sample

        Scenario: Missing # sample.feature:6
          Given missing   # sample.feature:7

        # Scenario comment
        @three
        Scenario: Passing # sample.feature:11
          Given passing   # sample.feature:12
            | a | b |
            | c | d |


       """

    Scenario: Add tags to specific scenario
      When I run cuketagger with "add:foo add:bar sample.feature:11"
      Then I should see:
        """
        # Feature comment
        @one
        Feature: Sample

          @two @three
          Scenario: Missing # sample.feature:6
            Given missing   # sample.feature:7

          # Scenario comment
          @three @foo @bar
          Scenario: Passing # sample.feature:11
            Given passing   # sample.feature:12
              | a | b |
              | c | d |


         """

    Scenario: Add and remove tags from feature
      When I run cuketagger with "remove:one add:bar sample.feature"
      Then I should see:
        """
        # Feature comment
        @bar
        Feature: Sample

          @two @three
          Scenario: Missing # sample.feature:6
            Given missing   # sample.feature:7

          # Scenario comment
          @three
          Scenario: Passing # sample.feature:11
            Given passing   # sample.feature:12
              | a | b |
              | c | d |


         """

    Scenario: Replace tags in feature
      When I run cuketagger with "replace:two:four sample.feature:6"
      Then I should see:
        """
        # Feature comment
        @one
        Feature: Sample

          @four @three
          Scenario: Missing # sample.feature:6
            Given missing   # sample.feature:7

          # Scenario comment
          @three
          Scenario: Passing # sample.feature:11
            Given passing   # sample.feature:12
              | a | b |
              | c | d |


         """

    Scenario: Replace non-existing tag
      When I run cuketagger with "replace:nope:four sample.feature:6"
      Then I should see 'expected "nope" at sample.feature:6, skipping' on stderr

    Scenario: Rewrite file
      When I run cuketagger with "--force remove:two remove:three sample.feature:6"
      Then the content of "sample.feature" should be:
        """
        # Feature comment
        @one
        Feature: Sample

          Scenario: Missing
            Given missing

          # Scenario comment
          @three
          Scenario: Passing
            Given passing
              | a | b |
              | c | d |


        """

