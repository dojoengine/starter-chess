// Component

#[starknet::component]
mod PlayableComponent {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::info::get_caller_address;
    use starknet::storage::Map as StorageMap;

    // Dojo imports

    use dojo::world::IWorldDispatcher;
    use dojo::world::IWorldDispatcherTrait;

    // Internal imports

    use chess::constants;
    use chess::store::{Store, StoreTrait};
    use chess::models::game::{Game, GameTrait, GameAssert};
    use chess::models::player::{Player, PlayerTrait, PlayerAssert};
    use chess::types::color::Color;

    // Errors

    mod errors {}

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn create(
            self: @ComponentState<TContractState>, world: IWorldDispatcher, name: felt252
        ) -> u32 {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Effect] Create game
            let game_id: u32 = world.uuid() + 1;
            let game = GameTrait::new(game_id);
            store.set_game(game);

            // [Effect] Create first player
            let color: u8 = Color::White.into();
            let player_id = get_caller_address().into();
            let player = PlayerTrait::new(game_id, color, player_id, name);
            store.set_player(player);

            // [Return] Game id
            game_id
        }

        fn join(
            self: @ComponentState<TContractState>,
            world: IWorldDispatcher,
            game_id: u32,
            name: felt252
        ) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Game is not started
            game.assert_not_started();

            // [Check] Black Player does not exist
            let color: u8 = Color::Black.into();
            let player = store.player(game_id, color);
            player.assert_not_exists();

            // [Effect] Create a new player
            let player_id = get_caller_address().into();
            let player = PlayerTrait::new(game_id, color, player_id, name);
            store.set_player(player);

            // [Effect] Start the game
            game.start();

            // [Effect] Update the game
            store.set_game(game);
        }

        fn move(
            ref self: ComponentState<TContractState>,
            world: IWorldDispatcher,
            game_id: u32,
            index: u8,
            to: u8
        ) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Game is started
            game.assert_is_started();

            // [Check] Game is not over
            game.assert_not_over();

            // [Check] Caller is player
            let player_id = get_caller_address().into();
            let player = store.player(game_id, game.color);
            player.assert_is_caller(player_id);

            // [Effect] Move
            game.move(index, to);

            // [Effect] Assess over
            game.assess_over();

            // [Effect] Update the game
            store.set_game(game);
        }
    }
}
