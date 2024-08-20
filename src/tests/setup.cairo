mod setup {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::testing::{set_contract_address, set_caller_address};

    // Dojo imports

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::utils::test::{spawn_test_world};

    // Internal imports

    use chess::models::index;
    use chess::models::game::Game;
    use chess::models::player::Player;
    use chess::systems::actions::{actions, IActions, IActionsDispatcher, IActionsDispatcherTrait};

    // Constants

    fn PLAYER() -> ContractAddress {
        starknet::contract_address_const::<'PLAYER'>()
    }

    fn ANYONE() -> ContractAddress {
        starknet::contract_address_const::<'ANYONE'>()
    }

    const PLAYER_NAME: felt252 = 'PLAYER';
    const ANYONE_NAME: felt252 = 'ANYONE';

    #[derive(Drop)]
    struct Systems {
        actions: IActionsDispatcher,
    }

    #[derive(Drop)]
    struct Context {
        player_id: felt252,
        player_name: felt252,
        anyone_id: felt252,
        anyone_name: felt252,
        game_id: u32,
    }

    #[inline(always)]
    fn spawn_game() -> (IWorldDispatcher, Systems, Context) {
        // [Setup] World
        let models = array![index::player::TEST_CLASS_HASH, index::game::TEST_CLASS_HASH,];
        let world = spawn_test_world("dojo_starter_chess", models);

        // [Setup] Systems
        let actions_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let systems = Systems {
            actions: IActionsDispatcher { contract_address: actions_address },
        };
        world.grant_writer(dojo::utils::bytearray_hash(@"dojo_starter_chess"), actions_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"dojo_starter_chess"), PLAYER());

        // [Setup] Context
        set_contract_address(PLAYER());
        let game_id = systems.actions.create(PLAYER_NAME);
        set_contract_address(ANYONE());
        systems.actions.join(game_id, ANYONE_NAME);
        let context = Context {
            player_id: PLAYER().into(),
            player_name: PLAYER_NAME,
            anyone_id: ANYONE().into(),
            anyone_name: ANYONE_NAME,
            game_id
        };
        set_contract_address(PLAYER());

        // [Return]
        (world, systems, context)
    }
}
