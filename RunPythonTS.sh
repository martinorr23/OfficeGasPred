chmod +x tsmapper.py
chmod +x tscombiner.py
chmod +x tsreducer.py
hdfs dfs -rm -r /SSPProj
hdfs dfs -rm -r /SSPProjOut
hdfs dfs -mkdir /SSPProj
wget https://x19155662timeseries.s3.amazonaws.com/OfficeData2.csv
hdfs dfs -copyFromLocal OfficeData2.csv /SSPProj
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar -files tsmapper.py,tsreducer.py,tscombiner.py -mapper mapper.py -reducer reducer.py -combiner tscombiner.py -input /SSPProjOut -output /SSPProjOut --cmdenv window_size=5
#hadoop-streaming -file tsmapper.py -mapper tsmapper.py -file tscombiner.py -combiner tscombiner.py -file tsreducer.py -reducer tsreducer.py -input /SSPProj -output /SSPProjOut --cmdenv window_size=5
rm part-00000
hdfs dfs -get /user/hduser/SSP/OfficeOut/part-00000 .
