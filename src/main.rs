use rnix::types::Lambda;
use rnix::types::{TypedNode, Wrapper};
use std::fs;
use std::path::PathBuf;

fn main() {
    entrypoint().unwrap();
}

fn entrypoint() -> Result<(), Box<dyn std::error::Error>> {
    println!("Hello, world!");

    let derivation_src = fs::read_to_string(PathBuf::from("./test.nix"))?;
    if derivation_src.trim().is_empty() {
        return Ok(());
    }

    let ast = rnix::parse(&derivation_src).as_result()?;
    for error in ast.errors() {
        println!("error: {}", error);
    }

    // Start traversing
    let root = ast.root().inner();
    if let Some(lambda) = root.and_then(Lambda::cast) {
        // Parse lambda args
        println!("lambda: {}", lambda.dump());
    }

    //println!("ast: {}", ast.root().dump());
    //println!("ast: {:#?}", ast);

    Ok(())
}
