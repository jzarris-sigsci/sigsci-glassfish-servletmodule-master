# Example Glassfish container running SigSci agent and Java servlet filter module
Signal Sciences Java servlet filter module for Glassfish

This example Docker image starts a Glassfish application, waits 60 seconds and then issues a cURL command to start the Administration Console. The SigSci agent process is then started. For a currently unknown reason, the SigSci module is not loaded until the Administration Console is accessed for the first time which is why the cURL command is part of the startup script. 
# sigsci-glassfish-servletmodule  
