chmod +x tsmapper.py
chmod +x tscombiner.py
chmod +x tsreducer.py
hdfs dfs -rm -r /SSPProjOutTwo
hdfs dfs -rm -r /SSPProjOutThree
hdfs dfs -rm -r /SSPProjOutFour
hdfs dfs -rm -r /SSPProjOutFive
hdfs dfs -rm -r /SSPProjOutSix
wget https://x19155662timeseries.s3.amazonaws.com/OfficeDataMR.csv
hdfs dfs -rm -r /SSPProj
hdfs dfs -mkdir /SSPProj
hdfs dfs -copyFromLocal OfficeDataMR.csv /SSPProj

#Hadoop streaming command, window size:2
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-D mapred.reduce.tasks=1 \
-file tsmapper.py \
-file tsreducer.py \
-file tscombiner.py \
-mapper "python3 ./tsmapper.py" \
-reducer "python3 ./tsreducer.py" \
-combiner "python3 ./tscombiner.py" \
-input /SSPProj/OfficeDataMR.csv \
-output /SSPProjOutTwo \
-cmdenv window_size=2

#Hadoop streaming command, window size:3
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-D mapred.reduce.tasks=1 \
-file tsmapper.py \
-file tsreducer.py \
-file tscombiner.py \
-mapper "python3 ./tsmapper.py" \
-reducer "python3 ./tsreducer.py" \
-combiner "python3 ./tscombiner.py" \
-input /SSPProj/OfficeDataMR.csv \
-output /SSPProjOutThree \
-cmdenv window_size=3

#Hadoop streaming command, window size:4
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-D mapred.reduce.tasks=1 \
-file tsmapper.py \
-file tsreducer.py \
-file tscombiner.py \
-mapper "python3 ./tsmapper.py" \
-reducer "python3 ./tsreducer.py" \
-combiner "python3 ./tscombiner.py" \
-input /SSPProj/OfficeDataMR.csv \
-output /SSPProjOutFour \
-cmdenv window_size=4

#Hadoop streaming command, window size:5
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-D mapred.reduce.tasks=1 \
-file tsmapper.py \
-file tsreducer.py \
-file tscombiner.py \
-mapper "python3 ./tsmapper.py" \
-reducer "python3 ./tsreducer.py" \
-combiner "python3 ./tscombiner.py" \
-input /SSPProj/OfficeDataMR.csv \
-output /SSPProjOutFive \
-cmdenv window_size=5

#Hadoop streaming command, window size:6
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-D mapred.reduce.tasks=1 \
-file tsmapper.py \
-file tsreducer.py \
-file tscombiner.py \
-mapper "python3 ./tsmapper.py" \
-reducer "python3 ./tsreducer.py" \
-combiner "python3 ./tscombiner.py" \
-input /SSPProj/OfficeDataMR.csv \
-output /SSPProjOutSix \
-cmdenv window_size=6

hadoop fs -getmerge /SSPProjOutTwo /home/hadoop/output/Two.csv
hadoop fs -getmerge /SSPProjOutThree /home/hadoop/output/Three.csv
hadoop fs -getmerge /SSPProjOutFour /home/hadoop/output/Four.csv
hadoop fs -getmerge /SSPProjOutFive /home/hadoop/output/Five.csv
hadoop fs -getmerge /SSPProjOutSix /home/hadoop/output/Six.csv
aws s3 cp /home/hadoop/output/* s3://x19155662timeseries/
#hdfs dfs -get /user/hduser/SSP//SSPProjOutSix/part-00000 .
