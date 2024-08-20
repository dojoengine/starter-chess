mod constants;
mod store;

mod elements {
    mod pieces {
        mod interface;
        mod pawn;
        mod rook;
        mod knight;
        mod bishop;
        mod queen;
        mod king;
    }
}

mod types {
    mod color;
    mod piece;
}

mod models {
    mod index;
    mod player;
    mod game;
}

mod helpers {
    mod bitmap;
    mod mapper;
    mod masker;
    mod math;
    mod packer;
    mod search;
}

mod components {
    mod playable;
}

mod systems {
    mod actions;
}

#[cfg(test)]
mod tests {
    mod setup;
    mod test_setup;
    mod test_move;
}
