# Secret Santas
(A coding exercise)

## Restrictions when assigning the Secret Santas:
- You cannot be your own Secret Santa.
- You cannot be assigned the same Secret Santa as the previous year.
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
- A participant does not have be included in each yearly event

#### Number of participants
- There will be sufficient number for each person to have a valid Secret Santa allocated to them
- The number will be a reasonable size of typically about 20 participants. Though no maximum will be set.

### Partners
- A participant may only have one partner each year
- The partner may be different or the same in another year.

### Distribution of a participants Secret Santas roles
- Receiving the name of the recipient of their Secret Santa gift is outside the scope of the exercise

## Design Features
### File loading
- The participants details are loaded from a CSV file
- Where a participant has a partner they are loaded together, separated by a ';'
- All participants in the file will be included in the current year.

### Reloading a file
- Replaces the current participants and any current Santa selection.

### Views
- List of this year's participants and Santa details.
- List of all participants
- Previous years participants and Santa details.

### Actions
- Load input file
- Generate a random Santas for each participant
- Delete Santa lists.

## Database Design

The Secret Santa event is an entity with many to many relationship to participants stored in the people table. Currently the Secret Santa has only one attribute - year. So just the people-secretsantas table has been created. Indexes have been created for each foreign key in the people-secretsantas table. (NB Rails model generate command requires --force-plural.)
The previous_santa_id field could be selected from previous year record when required, but the data is static once a new year record has been created. Hence it is more convenient to access via the current year people_secretsantas record than extract the data dynamically.
