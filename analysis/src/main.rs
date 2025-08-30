use std::collections::HashMap;

#[derive(serde::Deserialize)]
struct Helix {
    palette: HashMap<String, String>,
}

fn main() -> color_eyre::Result<()> {
    let raw = std::fs::read("../helix.toml")?;
    let obj: Helix = toml::from_slice(&raw)?;

    let mut names = vec![];
    let mut colors = vec![];

    for (k, v) in &obj.palette {
        let c = v.parse::<css_color_parser2::Color>()?;
        names.push(k);
        colors.push(rgb::Rgb {
            r: c.r,
            g: c.g,
            b: c.b,
        });
    }

    for i1 in 0..colors.len() {
        for i2 in (i1 + 1)..colors.len() {
            let contrast_ratio: f64 = ::contrast::contrast(colors[i1], colors[i2]);
            println!("{:>6} x {:6} = {contrast_ratio:.3}", names[i1], names[i2]);
        }
    }

    Ok(())
}
