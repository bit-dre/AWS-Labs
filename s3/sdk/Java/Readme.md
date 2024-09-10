''' 
mvn -B archetype:generate \
-DarchetypeGroupId=software.amazon.awssdk \
-DarchetypeArtifactId=archetype-lambda -Dservice=s3 -Dregion=US_EAST_1 \
-DarchetypeVersion=2.21.29 \
-DgroupId=com.example.myapp \
-DartifactId=myapp

'''