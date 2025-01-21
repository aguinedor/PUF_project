import csv

#definition of a function for loading csv files
def load_csv(file_path):
    cv_array = [] #initialize cv_array before writting in it

    try:
        #Load counter values from csv file to cv_array
        with open(file_path, 'r') as file: #open csv file in reading mode
            reader = csv.reader(file) #create an object reader to read file csv row by row
            for row in reader:
                #handling errors for invalid lines ex: lines with characters and no numbers
                if len(row) == 3:
                    try:
                        cv_array.append([int(row[1]), int(row[2])]) #add every line in a list of integers, but only column 2 and 3 that are counter values, the 1st is the challenge bit outpur and we don't care about it
                                                                #bidimensional array [N_RO_pair][2] Every line has 2 colums containing values of the 2 counters for a RO pair
                    except ValueError:
                        print("Error: impossible to convert", row, " in integer \n") #error if it's not possible to convert in integer
                else:
                    print("Error: line invalid", row, " does not have 3 columns \n") #error if there is a number of column different than 3 <=> bad line => possibly bad input file

        #Handling errors if csv file is empty or completely invalid    
        if not cv_array:
            print("Error: csv file empty or not valid \n")
            exit()
    
    except FileNotFoundError:
        print("Error: file", file_path, "is not found \n")
        exit()

    return cv_array


#definition of a function  for filtering
def RO_pair_filter(cv_array, speed, gap_min=20, gap_max=31000000000000000, filter_value=15000): #if threshold values and filter value are not declare, this is done automatically with arbitrary values [TO DETERMINE AND VERIFY]
    N_RO_pair = len(cv_array) #number of RO pairs, depending on how many rows there are in our array

    filtered_pairs_array = [] #creating list
    filtered_pairs = "" #creating output, I created an empty string (string is a character list)

    print(speed)    

    #converting speed of transmission into time of transmission
    if speed == "001":
        time = 1
    elif speed == "010":
        time = 0.1
    elif speed == "011":
        time = 0.01
    elif speed == "100":
        time = 0.001

    print(time)
    
    #loop to filter according to threshold values
    for i in range(N_RO_pair): #for(int i=0; i < N-RO_pair; i++)
        cv1, cv2 = cv_array[i] #assigning 2 values of a pair to variables cv1 and cv2 
        #converting counter values to counter frequencies to compare with whatever simulation time
        cf1 = cv1/time
        cf2 = cv2/time
        if gap_min <= abs(cf1 - cf2) <= gap_max: #we check if all counter values of the RO pair challenge are good (inside thresholds)
            filtered_pairs_array.insert(0,1) #if both are good then the pair can be used. So we write a 1 to indicate that it's a good RO pair
        else: #if not for the first, there is at least one counter value outside thresholds 
            filtered_pairs_array.insert(0,0) #so we can write a 0, because that's a bad pair #insert to add always at the beggining
    
    print("Number of RO pair valid after threshold filter = ", filtered_pairs_array.count(1), " \n ")

    #loop to filter too much close counter values
    for j in range(N_RO_pair):
        if filtered_pairs_array[j] == 1: #to test only good RO pairs, because if not there is not need to test them again
            cv1, cv2 = cv_array[j]
            cf1 = cv1/time
            cf2 = cv2/time
            if abs(cf1 - cf2) < filter_value: #to check if counter values are too much close
                filtered_pairs_array[j] = 0 #to indicate that RO pair is bad in case of cv too close, even if there are inside thresholds
 
    print("Number of RO pair valid = ", filtered_pairs_array.count(1), " \n ")
    print("This corresponds to this proportion : ", (filtered_pairs_array.count(1)/N_RO_pair)*100, " \n ")

    for k in range (len(filtered_pairs_array)):
        if filtered_pairs_array[k] == 1:
            filtered_pairs = filtered_pairs + "1"
        elif filtered_pairs_array[k] == 0:
            filtered_pairs = filtered_pairs + "0"

    return filtered_pairs

