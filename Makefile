lib/AndroidHiddenAPI.jar: AndroidHiddenAPI/android/app/ActivityManager.java AndroidHiddenAPI/android/app/ActivityThread.java AndroidHiddenAPI/android/content/pm/PackageParser.java AndroidHiddenAPI/android/os/FileUtils.java AndroidHiddenAPI/android/os/Process.java
	javac AndroidHiddenAPI/android/app/*.java AndroidHiddenAPI/android/content/pm/*.java AndroidHiddenAPI/android/os/*.java AndroidHiddenAPI/android/content/*.java
	cd AndroidHiddenAPI; jar -cvf ../lib/AndroidHiddenAPI.jar android/app/ActivityManager.class android/app/ActivityThread.class android/content/pm/PackageParser*.class android/os/FileUtils.class android/os/Process.class