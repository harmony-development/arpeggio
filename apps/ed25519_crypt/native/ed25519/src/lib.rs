#![allow(deprecated)]

// SPDX-FileCopyrightText: 2021 None
//
// SPDX-License-Identifier: CC0-1.0

extern crate rustler;

use ed25519_compact::*;
use rustler::*;
use pem::{parse_many, encode_many, Pem};

mod atoms {
    rustler::rustler_atoms! {
        atom ok;
        atom error;
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Ed25519",
    [
        ("generate_keys", 0, generate_keys, rustler::SchedulerFlags::DirtyCpu),
        ("encode_pem", 1, encode_pem, rustler::SchedulerFlags::DirtyCpu),
        ("decode_pem", 1, decode_pem, rustler::SchedulerFlags::DirtyCpu),
        ("public_key", 1, public_key, rustler::SchedulerFlags::DirtyCpu),
        ("sign", 2, sign, rustler::SchedulerFlags::DirtyCpu),
    ],
    Some(load)
}

struct Ed25519Key {
    kp: KeyPair
}

fn load(env: rustler::Env, _: rustler::Term) -> bool {
    rustler::resource!(Ed25519Key, env);

    true
}

type Data = resource::ResourceArc<Ed25519Key>;

fn generate_keys<'a>(env: Env<'a>, _args: &[Term<'a>]) -> Result<Term<'a>, rustler::Error> {
    let keypair = KeyPair::from_seed(Seed::generate());

    Ok(Data::new(Ed25519Key { kp: keypair }).encode(env))
}

fn encode_pem<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, rustler::Error> {
    let data: Data = args[0].decode()?;
    let key: &Ed25519Key = &*data;

    let pemdata = vec![
        Pem {
            tag: String::from("PUBLIC KEY"),
            contents: key.kp.pk.to_vec(),
        },
        Pem {
            tag: String::from("PRIVATE KEY"),
            contents: key.kp.sk.to_vec(),
        },
    ];

    let encoded = encode_many(&pemdata);

    Ok(encoded.encode(env))
}

fn public_key<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, rustler::Error> {
    let data: Data = args[0].decode()?;
    let key: &Ed25519Key = &*data;

    let mut data = match OwnedBinary::new(PublicKey::BYTES) {
        Some(it) => it,
        None => return Err(rustler::Error::BadArg)
    };
    data.copy_from_slice(key.kp.pk.as_ref());
    let bin = Binary::from_owned(data, env);

    Ok(bin.encode(env))
}

fn sign<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, rustler::Error> {
    let it: Binary = args[0].decode()?;

    let data: Data = args[0].decode()?;
    let key: &Ed25519Key = &*data;

    let a = key.kp.sk.sign(it.as_ref(), None);

    let mut data = match OwnedBinary::new(Signature::BYTES) {
        Some(it) => it,
        None => return Err(rustler::Error::BadArg)
    };
    data.copy_from_slice(a.as_ref());
    let bin = Binary::from_owned(data, env);

    Ok(bin.encode(env))
}

fn decode_pem<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, rustler::Error> {
    let data: Binary = args[0].decode()?;

    let pems = parse_many(data.as_slice());
    if pems.len() != 2 {
        return Ok((atoms::error()).encode(env))
    }

    let pubkey = match PublicKey::from_slice(&pems[0].contents) {
        Ok(v) => v,
        Err(_err) => return Ok((atoms::error()).encode(env))
    };

    let privkey = match SecretKey::from_slice(&pems[1].contents) {
        Ok(v) => v,
        Err(_err) => return Ok((atoms::error()).encode(env))
    };

    let kp = KeyPair {
        pk: pubkey,
        sk: privkey,
    };

    Ok(Data::new(Ed25519Key { kp }).encode(env))
}
