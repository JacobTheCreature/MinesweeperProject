cmake_minimum_required(VERSION 3.16)

project(ihopethisworks VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appihopethisworks
    main.cpp
)

qt_add_qml_module(appihopethisworks
    URI ihopethisworks
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES minesweepercell.h minesweepercell.cpp
    SOURCES
    SOURCES
    SOURCES difficultyselect.cpp
    SOURCES difficultyselect.h
    RESOURCES
    RESOURCES
    RESOURCES
    RESOURCES
    RESOURCES icons/flag-icon.png
    RESOURCES
    RESOURCES icons/bomb-icon.png
    RESOURCES icons/App-Icon.png
    RESOURCES icons/sad-face.png
    RESOURCES icons/smiley-face.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appihopethisworks PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appihopethisworks
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appihopethisworks
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appihopethisworks
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
