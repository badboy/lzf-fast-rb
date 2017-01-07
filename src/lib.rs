#[macro_use]
extern crate ruru;
extern crate lzf;

use std::convert::Into;
use std::fmt::{self, Display, Formatter};
use std::str;
use std::error::{self, Error};
use ruru::{Class, Object, RString, Fixnum, VM};

macro_rules! raise {
    ($($ex:tt)+) => {{
        VM::raise($($ex)+);
        unreachable!();
    }}
}

macro_rules! raise_lzf {
    ($ex:ident) => {{
        let ex : LzfError = $ex.into();
        VM::raise(ex.to_exception(), ex.description());
        unreachable!();
    }}
}

#[derive(Debug)]
struct LzfError(String);

impl LzfError {
    pub fn to_exception(&self) -> Class {
        Class::from_existing("RuntimeError")
    }
}

impl Display for LzfError {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "{}", <LzfError as error::Error>::description(&self))
    }
}
impl error::Error for LzfError {
    fn description(&self) -> &str {
        &self.0
    }
}

impl Into<LzfError> for lzf::LzfError {
    fn into(self) -> LzfError {
        LzfError(format!("{}", self))
    }
}

class!(LZF);

methods! {
    LZF,
    _itself,

    fn lzf_compress(data: RString) -> RString {
        let data = match data {
            Err(ref error) => raise!(error.to_exception(), error.description()),
            Ok(data) => data
        };

        match lzf::compress(data.to_string().as_bytes()) {
            Ok(compressed) => {
                RString::new(unsafe {
                    str::from_utf8_unchecked(&compressed)
                })
            }
            Err(err) => raise_lzf!(err),
        }
    }

    fn lzf_decompress(data: RString, len: Fixnum) -> RString {
        let data = match data {
            Err(ref error) => raise!(error.to_exception(), error.description()),
            Ok(data) => data
        };

        let len = match len {
            Err(ref error) => raise!(error.to_exception(), error.description()),
            Ok(len) => len
        };

        match lzf::decompress(data.to_string_unchecked().as_bytes(), len.to_i64() as usize) {
            Ok(decompressed) => {
                RString::new(unsafe {
                    str::from_utf8_unchecked(&decompressed)
                })
            },
            Err(err) => raise_lzf!(err),
        }
    }
}

#[no_mangle]
pub extern fn initialize_lzf() {
    Class::new("LZF", None).define(|itself| {
        itself.def_self("compress", lzf_compress);
        itself.def_self("decompress", lzf_decompress);
    });
}
