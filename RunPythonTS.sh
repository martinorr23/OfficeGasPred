hdfs dfs -rm -r /user/hduser/SSP/OfficeOut
mapred streaming -mapper ./tsmapper.py -combiner ./tscombiner.py -reducer ./tsreducer.py \
-input /user/hduser/SSPCopy -output /user/hduser/SSP/OfficeOut --cmdenv window_size=5
rm part-00000
hdfs dfs -get /user/hduser/SSP/OfficeOut/part-00000 .
