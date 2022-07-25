const deploy = async () => {
    //deployer is for deploy contracts 
    //from the network previusly configured
    //Signers get de config information for example private key
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contract Adress: ", deployer.address)
    //Get data of contract from factory
    const Kritons = await ethers.getContractFactory("Kritons");
    //Initializing contract
    const deployed = await Kritons.deploy();

    //Get block address
    console.log("Kritons is deployed at :", deployed.address);
};

//0 = GOOD 1 = WRONG
deploy().then(() => process.exit(0)).catch(error => {
    console.log(error);
    process.exit(1)
}
    );