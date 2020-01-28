#!/usr/local/bin/perl

# programmer: yechen (BGI)
# e-mail:yech@genomics.org.cn
$version=1.00;  #2001-09-13 by yechen
                #切割 Read 为指定长度的小片断

$version=1.10;  #2001-09-24 by yechen
                #添加一些注释
                #产生切断现象的原因跟踪和调试
                #本程序的输出可以再作为输入，从而达到最终的收敛极限。此时输出结果完全等同输入结果。

$version=1.15;  #2001-09-30 by yechen
                #发现 1.10 版 依旧存在产生切断现象  ..... 原因跟踪和调试
                #本程序的输出可以再作为输入，从而达到最终的收敛极限。此时输出结果完全等同输入结果。

$version=1.20;  #2001-10-01 by yechen
                #自动决断收敛
######################################################################################			
# from version 1.00 to version 1.20, name of program is scan_blast_to_cluster.pl
######################################################################################			

$version=1.30;  #2001-10-06 by yechen
                #更改文件名称：
                #from scan_blast_to_cluster.pl 
                #to merge_cluster.pl 

$version=1.35;  #2001-10-26 by yechen
				#最后统计 Singlets 数目

$version=1.50;  #2001-12-17 by yechen
				#应用调试开关代码
				#每组元素排序, 未实现
				#修正产生 Singlet 问题
				#修正产生 异组合并 问题


$DEBUG = 0;		#调试开关

    print("============================================================\n");
    print("$0 (Version $version)\n");
    print("============================================================\n");
    die("Usage:\n$0 <Groups_List_File>\n\n") if (@ARGV<1);

    ($Groups_List_File) = @ARGV;

    print "Groups_List_File  = $Groups_List_File\n";

    $Time_Start = sub_format_datetime(localtime(time()));
    print "Now = $Time_Start\n";
    print "\n";

    print "\n----------------------------------------\n" if($DEBUG);
    print "\nStep 1:\n" if($DEBUG);
    print "\n----------------------------------------\n" if($DEBUG);
	print "Open [$Groups_List_File]...\n";
    open(FILEHANDLE_CLUSTER_LIST, "<$Groups_List_File") || die ("ERROR! Can't reading [$Groups_List_File]\n");

    %Units_Name = ();             #所有原始分组中的 Read 或 Unit 名称的哈希数组
    @Units_of_Cluster = ();       #原始分组所包含的 Reads 或 Unit 集合(字符串形式)
    @Clusters_of_Unit = ();       #每个 Read　对应的分组编号
    @Cluster_Number_of_Unit = (); #元素出现次数
    @Name_of_Unit =();
	
    $Unit_Current  = 0;
    $Cluster_Current = 0;
    $Error_Line = 0;
    while(<FILEHANDLE_CLUSTER_LIST>)
    {
        chomp;
        #print "$Cluster_Current [$_]\n" if (!($Cluster_Current % 1000));

        $Units_of_Cluster[$Cluster_Current] = "$_";   # 读入当前的原始分组内容

        $Element_Number_Of_Line = 0;
        foreach(split(" ", $_))                         # 切分当前原始分组中的每个元素
        {
            if( !exists($Units_Name{$_}))
	        {   # 当前元素从未读入
    	        $Units_Name{$_} = $Unit_Current;                        # 赋予前元素一个对应的元素编号, 记录当前元素名称
        	    $Name_of_Unit[$Unit_Current]           = $_;            # 记录当前元素名称
            	$Clusters_of_Unit[$Unit_Current] = "$Cluster_Current "; # 累加原始组编号到当前元素的分组纪录数组中
            	$Cluster_Number_of_Unit[$Unit_Current] = 1;             # 当前元素出现次数累加
            	$Unit_Current++;
        	}
        	else
        	{   # 当前元素已读过
            	$Unit_No = $Units_Name{$_};                             # 取当前元素编号
            	$Clusters_of_Unit[$Unit_No] .= "$Cluster_Current ";     # 累加原始组编号到当前元素的分组纪录数组中
            	$Cluster_Number_of_Unit[$Unit_No]++;                    # 当前元素出现次数累加
        	}
        	$Element_Number_Of_Line++;
        }

        #允许原始分组中存在只含单个元素的分组，但将报警
        #可以通过对运行结果的再次处理检验错误。
        if ($Element_Number_Of_Line<2)
        {
            $Error_Line++;
            print "!Alert.$Error_Line [$Cluster_Current] Line. = $Element_Number_Of_Line] $_\n";
        }

        $Cluster_Current++;
        
    }
    close(FILEHANDLE_CLUSTER_LIST)       || die("ERROR! Can't close FILEHANDLE_CLUSTER_LIST");

    $Units_Number = $Unit_Current;
    $Cluster_Number = $Cluster_Current;         # 原始分组总数
    print "\nTotal $Units_Number Units\n";
    print "Total $Cluster_Number Groups\n";
    print "Total $Error_Line Singlets\n";
	print "\n";

	
    # 初始化新分类数组，$Cluster_New[旧分类号]=新分类号
    print "\n----------------------------------------\n" if($DEBUG);
    print "\nStep 2:\n" if($DEBUG);
    print "\n----------------------------------------\n" if($DEBUG);
    for($i=0; $i<$Cluster_Number; $i++)
    {
        $Cluster_New[$i] = $i; print "\n>>Cluser $Cluster_New[$i]" if($DEBUG);
    }

    print("\n____________________________________________________________\n");
    $Time_End = sub_format_datetime(localtime(time()));
    print "Running from [$Time_Start] to [$Time_End]\n";

    # 降解归并每个元素所在的组编号
    print "\n----------------------------------------\n" if($DEBUG);
    print "\nStep 3:\n" if($DEBUG);
    print "\n----------------------------------------\n" if($DEBUG);
    $Loops = 1;
    do
    {
        print "\nLoops $Loops .... ";
        $Unit_Current = 0;
        $Updated_Number = 0;

        foreach(@Clusters_of_Unit)
        {
            #当目标元素出现的一个以上组时
            if ($Cluster_Number_of_Unit[$Unit_Current]>1)
            {
                print "\nUnit.$Unit_Current [$Name_of_Unit[$Unit_Current]] ".$Cluster_Number_of_Unit[$Unit_Current]." clusters:\n" if($DEBUG);
                #reset_clusters_of_units($Unit_Current);
                @Clusters = split(/ /, $Clusters_of_Unit[$Unit_Current]); #@Clusters = sort {$a<=>$b} (split(/ /, $Clusters_of_Unit[$Unit_Current]));
                @Old_Cluster_Stack = ();

                print "\tOld_Cluster_Stack:\n" if($DEBUG);
                foreach(@Clusters)
                {
                    $Old_Cluster = $_;
                    while( $Old_Cluster != ($New_Cluster = $Cluster_New[$Old_Cluster]) )
                    {
                        print "\t<$Old_Cluster -> $New_Cluster>\n" if($DEBUG);
                        push(@Old_Cluster_Stack, $Old_Cluster = $New_Cluster);
                    }
                }

                $Min_Cluster = $Cluster_Number;
                print "\n\tFinding Min_Cluster from $Min_Cluster:" if($DEBUG);
                @Clusters = (@Clusters, @Old_Cluster_Stack);
                foreach(@Clusters)
                {
                    print "\n\t$_, New[$_]=$Cluster_New[$_], Min_Cluster=$Min_Cluster" if($DEBUG);
                    $Min_Cluster = $Cluster_New[$_] if ($Min_Cluster > $Cluster_New[$_]);
                }
                print "\n\n\tset all to Min_Cluster=$Min_Cluster:" if($DEBUG);
                $Cluster_i=0;

                foreach(@Clusters)
                {
                   	print "\n\tNew[$_]=$Cluster_New[$_]=>$Min_Cluster" if($DEBUG);
                   	
                   	if ($Cluster_New[$_] != $Min_Cluster)
                   	{
                   		$Cluster_New[$_] = $Min_Cluster;
                   		$Cluster_i++;
                   		print " !" if($DEBUG);
                   	}
                }
                print "\n\tModified {$Cluster_i} Clusters.\n" if($DEBUG);
                $Updated_Number += $Cluster_i;
            }
            $Unit_Current++;
        }

        print "\nUpdated_Number = $Updated_Number\n";
        $Loops++;

    } while($Updated_Number);

    print("\n____________________________________________________________\n");
    $Time_End = sub_format_datetime(localtime(time()));
    print "Running from [$Time_Start] to [$Time_End]\n";

    #清理不再使用的数据
    print "\n----------------------------------------\n" if($DEBUG);
    print "\nStep 4:\n" if($DEBUG);
    print "\n----------------------------------------\n" if($DEBUG);
    @Units_of_Cluster = ();       #原始分组所包含的 Reads 或 Unit 集合(字符串形式)
    @Cluster_Number_of_Unit = ();

    print "\nSorting...";
    @Sorted_Group = ();
    $Unit_Current=0;
    foreach(@Clusters_of_Unit)
    {
        print "\nUnit.$Unit_Current [$Name_of_Unit[$Unit_Current]]---".$Cluster_New[$Clusters_of_Unit[$Unit_Current]] if($DEBUG);
        $Sorted_Group[$Unit_Current] = sprintf("%010d %s", $Cluster_New[$Clusters_of_Unit[$Unit_Current]], $Name_of_Unit[$Unit_Current]);
        $Unit_Current++;
    }

    @Sorted_Group = sort(@Sorted_Group);

    print("\n____________________________________________________________\n");
    $Time_End = sub_format_datetime(localtime(time()));
    print "Running from [$Time_Start] to [$Time_End]\n";

    print "\n----------------------------------------\n" if($DEBUG);
    print "\nStep 5:\n" if($DEBUG);
    print "\n----------------------------------------\n" if($DEBUG);
    print "\nWriting [$Groups_List_File.group]...\n";
    open(FILEHANDLE_CLUSTER_LIST, ">$Groups_List_File.group") || die ("ERROR! Can't Creating [$Groups_List_File.group]\n");

    $Group_i=0; $Group_Number=""; $Group_num=0; $Singlets_Number=0;
    foreach(@Sorted_Group)
    {
        if($Group_Number ne substr($_, 0, 10))
        {
            if ($Group_i)
            {
            	print FILEHANDLE_CLUSTER_LIST "\n";
            	if ($Group_num<2)
            	{
            		$Singlets_Number++;
	            	print "!S!\n" if($DEBUG);
            	}
            }
            $Group_i++;
            $Group_num = 1;
            $Group_Number = substr($_, 0, 10);
            #print FILEHANDLE_CLUSTER_LIST sprintf("%08d ", $Group_i);
        }
		else
		{
	        $Group_num++;
		}
        print "Group $Group_i: [$_]\n" if($DEBUG);

        #print FILEHANDLE_CLUSTER_LIST sprintf("%08d", $Group_i).substr($_, 10)."\n";
        print FILEHANDLE_CLUSTER_LIST substr($_, 11)." ";
    }
    print FILEHANDLE_CLUSTER_LIST "\n";
    close(FILEHANDLE_CLUSTER_LIST);

    print "Total $Group_i Groups\n";
	if ($Singlets_Number)
	{
		print "WARNING! $Singlets_Number Singlets\n";
	}
	

    print("\n____________________________________________________________\n");
    $Time_End = sub_format_datetime(localtime(time()));
    print "Running from [$Time_Start] to [$Time_End]\n";
    print("............................................................\n");

;

#_____________________________________________________
sub reset_clusters_of_units
{
    local($Unit_No)=(@_);
    local(@Clusters)=();
    local($Min_Cluster)=0;
    local($This_Cluster)=0;
    #print "\n\t==>Unit.$Unit_No [$Name_of_Unit[$Unit_No]] $Cluster_Number_of_Unit[$Unit_No] clusters:";

    local(@Clusters) = sort {$a<=>$b} (split(/ /, $Clusters_of_Unit[$Unit_No]));
    #foreach(@Clusters){print "\n\t\t$_";}

    $Min_Cluster = $Clusters[0];
    #print "\n\t\t[a]=$Min_Cluster";

    foreach(@Clusters)
    {
        #print "\n\t\t[b] $_ $Cluster_New[$_] = $Min_Cluster";
        $Min_Cluster = $Cluster_New[$_] if ($Min_Cluster > $Cluster_New[$_]);
    }

    foreach(@Clusters)
    {
        #print "\n\t\t[c] $Clusters[$_]=>$Cluster_New[$_]=>$Min_Cluster";
        $Cluster_New[$_] = $Min_Cluster;
    }

    #print "\n";
};

# -------------------------------------------------------------------------------
sub sub_format_datetime
{
    local($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = @_;
    sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon, $day, $hour, $min, $sec);
};

