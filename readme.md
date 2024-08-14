# Ticket nr 5555

- Add devise for simple auth of a users
- Add Messages controller and view to display messages and hide messages 
- Add TurboChatClient to handle API call to hide messages
- Add  attachments_file_paths to xadd action in order to sent paths to attachments with message into redis
- Make common storage folder in order to store attachments for both applications
- Add MessagesCreator responsible for parsing stream and create messages with attachments in DB 
- Add RedisMessagesListener responsible for running in a background and reading a stream and call MessagesCreator serivce
- Add RedisMessagesListener to initializer in order to run it on a start of the rails server
