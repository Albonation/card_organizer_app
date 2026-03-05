# Architecture

## Folder Structure

### lib/
    - main.dart
    Sets up the app's main entry point.
    Sets the app's theme.

### database/
    - database_helper.dart
    Opens DB and defines schema

### models/
    - folder.dart
        id, name, timestamp
    - card_item.dart  //to avoid clashing with Flutter's Card widget
        id, cardName, suit, imageUrl, folderId (foreign key)

### repositories/
    - folder_repository.dart
        insertFolder()        
        getAllFolders(),
        getFolderById(),
        updateFolder(),
        deleteFolder(),
        getFolderCount(),
    - card_repository.dart
        insertCard()        
        getAllCards(),
        getCardByFolderId(),
        getCardById(),
        updateCard(),
        deleteCard(),
        getCardCountByFolder(),
        moveCardToFolder(),

### screens/
    - folders_screen.dart
        calls folder and card repositories
        shows folder grid and counts
        navigates to cards screen
    - cards_screen.dart
        receives a folder id from folders screen
        calls getCardsByFolder(folder.id)
        shows cards in a grid or list
        add/edit/delete actions
    - add_edit_card_screen.dart
        form UI
        on save, calls insertCard() or updateCard()
        pops back and triggers refresh