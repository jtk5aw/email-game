use wasm_bindgen::prelude::wasm_bindgen;
use wasm_bindgen::prelude::JsValue;

#[wasm_bindgen(start)]
pub fn main() -> Result<(), JsValue> {
    // Get the document
    let window = web_sys::window().unwrap();
    let document = window.document().unwrap();

    // Create a div element
    let div = document.create_element("div")?;

    // Set the text content
    div.set_text_content(Some("Hello World"));

    // Style the div for center positioning
    // Style the div for center positioning
    div.set_attribute(
        "style",
        "position: absolute; \
         top: 50%; \
         left: 50%; \
         transform: translate(-50%, -50%); \
         font-family: Arial, sans-serif; \
         font-size: 24px;",
    )?;

    // Append the div to the body
    let body = document.body().unwrap();
    body.append_child(&div)?;

    Ok(())
}
