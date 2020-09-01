chmod +x tsmapper.py
chmod +x tscombiner.py
chmod +x tsreducer.py
hdfs dfs -rm -r /SSPProj
hdfs dfs -rm -r /SSPProjOut
hdfs dfs -mkdir /SSPProj
wget https://x19155662timeseries.s3.amazonaws.com/OfficeDataMR.csv
hdfs dfs -copyFromLocal OfficeDataMR.csv /SSPProj

#Hadoop streaming command
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-file tsmapper.py \
-file tsreducer.py \
-file tscombiner.py \
-mapper "python3 ./tsmapper.py" \
-reducer "python3 ./tsreducer.py" \
-combiner "python3 ./tscombiner.py" \
-input /SSPProj/OfficeDataMR.csv \
-output /SSPProjOut \
-cmdenv window_size=5

#hadoop-streaming -file tsmapper.py -mapper tsmapper.py -file tscombiner.py -combiner tscombiner.py -file tsreducer.py -reducer tsreducer.py -input /SSPProj -output /SSPProjOut --cmdenv window_size=5
rm part-00000
hdfs dfs -get /user/hduser/SSP/OfficeOut/part-00000 .
