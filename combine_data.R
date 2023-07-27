combine_data <- function(faasr) {

  # retrieve the arguments for this function
  # This function takes two input file names and one output file name as arguments
  # these become available as args$input1, args$input2, and args$output
  #
  args <- faasr_get_user_function_args(faasr)
  
  # Download the input files from S3 bucket
  # The bucket is configured in the JSON payload as S3_A
  # In this demo code, all inputs/outputs are in the same S3 folder, named "demo1-data" below
  # The downloaded files are stored in a "local" folder under names input1.csv and input2.csf
  #
  faasr_get_file(faasr, "S3_A", "demo1-data", args$input1, "local", "input1.csv")
  faasr_get_file(faasr, "S3_A", "demo1-data", args$input2, "local", "input2.csv")
  
  # This demo function computes output <- input1 + input2 and stores the output back into S3
  # First, read the local inputs, compute the sum, and store the output locally
  # 
  input1 <- read.table("local/input1.csv", sep=",", header=T)
  input2 <- read.table("local/input2.csv", sep=",", header=T)
  output <- input1 + input2
  write.table(output, file="local/output.csv", sep=",", row.names=F, col.names=T)

  # Now, upload the output file to the S3 bucket
  #
  faasr_put_file(faasr, "S3_A", "local", "output.csv", "demo1-data", args$output)

  # Print a log message
  # 
  log_msg <- paste0('Function combine_data finished; output written to demo1-data/', args$output, ' in bucket S3_A defined in the JSON configuration')
  faasr_log(faasr, log_msg)
}	
