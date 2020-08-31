chmod +x tsmapper.py
chmod +x tscombiner.py
chmod +x tsreducer.py
hdfs dfs -rmdir /SSPProj
hdfs dfs -mkdir /SSPProj
wget https://x19155662timeseries.s3.amazonaws.com/OfficeData2.csv
hdfs dfs -copyFromLocal OfficeData2.csv /SSPProj
hadoop-streaming -mapper tsmapper.py -combiner tscombiner.py -reducer tsreducer.py -input /SSPProj -output /SSProjOut --cmdenv window_size=5
rm part-00000
hdfs dfs -get /user/hduser/SSP/OfficeOut/part-00000 .
