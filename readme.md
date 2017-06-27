# A coding exercise

## Restrictions when assigning the Secret Santas:
- You cannot be your own Secret Santa.
- You cannot be assigned the same Secret Santa that you got in the previous year.
- You cannot be your partner’s Secret Santa.

## Assumptions
### Running of the Secret Santa
- There will only be one event each year
- There will only be one group of participants each year
- Other information like the location of the gift exchange and maximum spend will be communicated to the participants outside of this exercise.

### Participants
- Each participant has a unique name
 and can be used to to identify themselves to their Santa.
- The number of participants may be different each year
- A participant may not be included in each yearly event
#### Number of participants
- There will be sufficient number for each person to have a valid Secret Santa allocated to them
- The number will be a reasonable size of typically about 20 participants. Though no maximum will be set it is assumed to be 50 or less participants.
- The number of participants will be at least 3 without partners.

### Partners
- A participant may only have one partner each year
- The partner may be different or the same in another year.

### Distribution of Santas list
- Each participant will have their own email address to receive the name of the recipient of their gift.

## Design Features
### File loading
- The participants details are loaded from a CSV file
- All participants in the file will be for the current year.

### Reloading a file
- Previously loaded participants will have their details updated.
- Overwritten participants details will not be kept.  
- Replaces the current participants and any current Santa selection.
- A participant who is no longer in the list will not cause them to be removed from the list of known persons.

### Views
- List of this year's participants.
- List Santa selections
- Previous years participants and Santa details.

### Actions
- Load input file
- Generate Santas for each participant
- Delete previous Santa lists older than current or previous year. This includes people who are no longer part of a saved Sanata list.

-Create a random recipient for each Santa where they are not their partner and not the previous year's recipient.  
Store the Santa list
View Santa list
Distribute the name of the gift recipient to each Santa
Redistribute the name of the gift recipient if their Santa forgets it
Delete a participants list for a year and associated Santa's list. (Should this be allowed for the previous year?)
