compute_division <- function(folder, input1, input2, output) {

  # retrieve the arguments for this function
  # This function takes two input file names and one output file name as arguments
  # these become available as args$input1, args$input2, and args$output
  #
  
  # Download the input files from S3 bucket
  # The bucket is configured in the JSON payload as My_S3_Bucket
  # In this demo code, all inputs/outputs are in the same S3 folder, which is also configured by the user
  # The downloaded files are stored in a "local" folder under names input1.csv and input2.csf
  #
  source("faasr_get_file.R")
  source("faasr_put_file.R")
  source("faasr_log.R")
  
  faasr_get_file("My_S3_Bucket", folder, input1, "local", "input1.csv")
  faasr_get_file("My_S3_Bucket", folder, input2, "local", "input2.csv")
  
  # This demo function computes output <- input1 / input2 and stores the output back into S3
  # First, read the local inputs, compute the sum, and store the output locally
  # 
  input1 <- read.table("local/input1.csv", sep=",", header=T)
  input2 <- read.table("local/input2.csv", sep=",", header=T)
  output_set <- input1 / input2
  write.table(output_set, file="local/output.csv", sep=",", row.names=F, col.names=T)

  # Now, upload the output file to the S3 bucket
  #
  faasr_put_file("My_S3_Bucket", "local", "output.csv", folder, output)

  # Print a log message
  # 
  log_msg <- paste0('Function compute_division finished; output written to ', folder, '/', output, ' in My_S3_Bucket defined in the JSON configuration')
  faasr_log(log_msg)
}	
